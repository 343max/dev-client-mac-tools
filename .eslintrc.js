module.exports = {
  root: true,
  extends: ['universe/native', 'prettier'],
  ignorePatterns: ['build'],
  plugins: ['react', 'react-hooks', '@typescript-eslint', 'no-type-assertion', 'eslint-plugin-prettier'],
};
